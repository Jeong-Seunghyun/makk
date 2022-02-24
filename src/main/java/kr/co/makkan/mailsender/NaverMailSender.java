package kr.co.makkan.mailsender;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang.RandomStringUtils;

import lombok.extern.log4j.Log4j;

@Log4j
public class NaverMailSender {

	public String mailSender(String userEmail) {
		
		log.info("Email Sender-----------");
		
		// 임시 비밀번호 생성
		RandomStringUtils random = new RandomStringUtils();
		String newPwChar = random.randomAlphanumeric(9);
		String newPwAscii = random.random(3, 33, 38, false, false);
		String newPw = newPwChar+newPwAscii;
		
		// mail server 설정
		String host = "smtp.naver.com";
		String user = "makkantest123@naver.com"; // 자신의 네이버 계정
		String password = "testproject";// 자신의 네이버 패스워드

		// SMTP 서버 정보를 설정한다.
		Properties props = new Properties();
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", 465);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.debug", "true");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // TLS 버전 설정 중요!

		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, password);
			}
		});

		// email 전송
		try {
			MimeMessage msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(user, "makkan manager"));
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(userEmail));

			// 메일 제목
			msg.setSubject("임시 비밀번호 확인을 위한 메일입니다.");
			// 메일 내용
			msg.setText("임시 비밀번호는  " + newPw + "  입니다. \n로그인 후 비밀번호를 반드시 변경해주세요.");

			Transport.send(msg);

		} catch (Exception e) {
			e.printStackTrace();
		}
		log.info("New Password : " + newPw);
		return newPw;
	}

}
