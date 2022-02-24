package kr.co.makkan.member.domain;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Data
@ToString
public class MemberDTO {
	private String userid;
	private String userpw;
	private String name;
	private Date indate;
	private String zipcode;
	private String address;
	private String detailAddr;
	private String phone;
	private char dropUser;
	private String email;
	private List<AuthDTO> authList;
}
