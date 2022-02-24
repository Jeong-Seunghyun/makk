package kr.co.makkan.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.makkan.coolsms.SendSMS;
import kr.co.makkan.mailsender.NaverMailSender;
import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.service.IMemberService;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class MemberController {
	
	@Autowired
	private IMemberService service;
	@Autowired
	private BCryptPasswordEncoder encoder;
	
	//ID.PW찾기 화면 이동
	@GetMapping("/forgot")
	public String forgot() {
		log.info("find------------");
		return "/member/find";
	}
	
	//회원가입 폼화면 이동
	@GetMapping("/signupForm")
	public String signupForm() {
		log.info("Signup Form------------");
		return "/member/signup";
	}
	
	//ID 중복확인.. 
	@PostMapping("/idCheck")
	@ResponseBody
	public int idCheck(String id) {
		log.info("id check........");
		String user = service.idCheck(id);
		log.info("입력한 아이디 : "+id+" 기존 회원 아이디 : " +user);
		int result = user == null ? 1 : 0;
		return result;
	}
	
	//SMS인증번호 발송
	@PostMapping("/sendSMS")
	@ResponseBody
	public String sendSMS(@RequestParam("phone") String phoneNum) {
		log.info("sendSMS -----------");
		SendSMS sms = new SendSMS();
		// 난수 생성 (더블타입 int 형변환)
		int random = (int) ((Math.random() * (9999 - 1000 + 1)) + 1000);
		sms.sendAction(phoneNum, random);
		log.info(random);
		return Integer.toString(random);
	}
	
	//회원가입 submit
	@PostMapping("signupSubmit")
	public String signup(@RequestParam("userid") String id, @RequestParam("userpwd1") String pwd, @RequestParam("username") String name
			,@RequestParam("emailid")String email, @RequestParam("emailaddr")String emailAddr, @RequestParam("phone") String phone,
			@RequestParam("zipcode") String zipcode, @RequestParam("addr")String addr, @RequestParam("addr-detail")String detailAddr){
		log.info("signup Action-----------");
		
		MemberDTO mDto = new MemberDTO();
		mDto.setUserid(id);
		mDto.setUserpw(encoder.encode(pwd));
		mDto.setEmail(email+"@"+emailAddr);
		mDto.setPhone(phone);
		mDto.setName(name);
		mDto.setZipcode(zipcode);
		mDto.setAddress(addr);
		mDto.setDetailAddr(detailAddr);
		
		
		service.insertMember(mDto);
		
		return "/member/signsuccess";
	}
	
	//회원정보 수정
	@PostMapping("/modifyAction") 
	public String modifyAction(@RequestParam("userid") String id, @RequestParam("originPW") String originPwd, 
			@RequestParam("emailid")String email, @RequestParam("emailaddr")String emailAddr,@RequestParam("userpwd1") String newPwd,
			@RequestParam("zipcode") String zipcode, @RequestParam("addr")String addr, @RequestParam("addr-detail")String detailAddr
			, RedirectAttributes rttr) {
		log.info("modify submit-------------");
		
		MemberDTO mDto = service.selectMe(id);
		if (encoder.matches(originPwd, mDto.getUserpw())) { //기존 비밀번호가 맞아야만 실행
			if (!newPwd.equals("")) { //비밀번호 변경을 시도했다면 실행
				mDto.setUserpw(encoder.encode(newPwd));
			} else {
				mDto.setUserpw(null);
			}
			if (!email.equals("")) { //이메일 주소를 입력받았다면 실행
				mDto.setEmail(email+"@"+emailAddr);
			}
			if (!zipcode.equals("")) { //주소를 입력했다면 실행
				mDto.setZipcode(zipcode);
				mDto.setAddress(addr);
				mDto.setDetailAddr(detailAddr);
			}
			
			log.info(mDto.toString());
			
			int result = service.modifyMember(mDto);
			
			if (result > 0) {
				rttr.addFlashAttribute("success", "회원정보가 수정되었습니다. 다시 로그인 해주세요");
				return "redirect:/";
			}else {
				rttr.addFlashAttribute("fail", "System error!!");
				return "redirect:/";
			}
		}else {
			rttr.addFlashAttribute("message", "현재 비밀번호가 올바르지 않습니다.");
			return "redirect:/modifyMember";
		}
	}
	
	//비밀번호 발송
	@PostMapping("/findPassword")
	public String findPassword(@RequestParam("id") String id, @RequestParam("email") String email ,
			RedirectAttributes rttr) {
		log.info("Password Find-----------");
		NaverMailSender mailSender = new NaverMailSender();
		MemberDTO mDto = service.selectMe(id); 
		
		if (mDto == null) { //ID 값으로 회원 조회, null이면 return
			rttr.addFlashAttribute("message","등록된 회원이 아닙니다.");
			return "redirect:/forgot";
		}
		
		if (mDto.getEmail().equals(email)) { //ID로 회원조회 성공시 email이 일치하는지 확인, 불일치시 return
			String newPass = mailSender.mailSender(email);
			mDto.setUserpw(encoder.encode(newPass)); //임시 비밀번호 암호화 및 DB에 업데이트
			service.modifyMember(mDto);
			rttr.addFlashAttribute("message", "메일이 발송되었습니다. 메일 확인 후 로그인 해주세요.");
			return "redirect:/loginForm";
		} else {
			rttr.addFlashAttribute("message", "ID 또는 email이 일치하지 않습니다.");
			return "redirect:/forgot";
		}
		
	}
}
