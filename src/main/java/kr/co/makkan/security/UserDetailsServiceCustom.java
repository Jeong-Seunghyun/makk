package kr.co.makkan.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.co.makkan.member.domain.AuthDTO;
import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.mapper.MemberMapper;
import lombok.extern.log4j.Log4j;

@Log4j
@Service //security context에서 bean을 생성하도록 선언.. 이름을 지정하지 않으면 앞글자만 소문자
public class UserDetailsServiceCustom implements UserDetailsService{
	

	@Autowired
	MemberMapper mapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		log.info("user mapping--------");
		MemberDTO mDto = mapper.selectUser(username);
		//최종 리턴객체 .. DB에서 불러온 사용자의 정보를 set -> 완전한 UserDetails객체를 리턴해야만 작동
		UserDetailsDTO userDetail = new UserDetailsDTO();
		
		if (mDto == null) {
			return null;
		} else {
			userDetail.setUsername(mDto.getUserid());
			userDetail.setPassword(mDto.getUserpw());
			
			List<String> authList = new ArrayList<String>();
			for (AuthDTO authDTO : mDto.getAuthList()) {
				authList.add(authDTO.getAuth());
			}
			userDetail.setAuthorities(authList);
			
		}
		log.info("custom user info---------" + userDetail.getAuthorities());
		
		return userDetail;
	}

}
