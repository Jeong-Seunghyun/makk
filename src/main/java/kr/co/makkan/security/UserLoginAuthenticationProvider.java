package kr.co.makkan.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class UserLoginAuthenticationProvider implements AuthenticationProvider{
	
	
	@Autowired
	private BCryptPasswordEncoder pwEncoder;
	
	@Autowired
	private UserDetailsService userDetailsService;
	
	@SuppressWarnings("unused")
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		//사용자 입력정보
		log.info("login provider-------");
		
		String username = (String) authentication.getPrincipal();
		String userPw = (String) authentication.getCredentials();
		//DB에서 가져온 암호화된 user의 정보
		UserDetailsDTO userDetails = (UserDetailsDTO) userDetailsService.loadUserByUsername(username);
		
		//matches 메서드로 form password와 DB password를 비교
		if (userDetails == null ) {
			throw new AuthenticationServiceException(username);
		}
		
		if (!username.equals(userDetails.getUsername()) || 
				!pwEncoder.matches(userPw, userDetails.getPassword())) {
			throw new BadCredentialsException(username);
		} 

		userDetails.setPassword(null);
		
		// 최종 리턴 시킬 새로만든 Authentication 객체
		Authentication newAuth = new UsernamePasswordAuthenticationToken(
				userDetails, null, userDetails.getAuthorities());
		
		log.info(newAuth.getPrincipal());
		log.info(newAuth.getName());
		
		return newAuth;
	}

	@Override
	// 위의 authenticate 메소드에서 반환한 객체가 유효한 타입이 맞는지 검사
	// null 값이거나 잘못된 타입을 반환했을 경우 인증 실패로 간주
	public boolean supports(Class<?> authentication) {
		
		// 스프링 Security가 요구하는 UsernamePasswordAuthenticationToken 타입이 맞는지 확인
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

}
