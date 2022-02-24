package kr.co.makkan.member.service;

import kr.co.makkan.member.domain.MemberDTO;

public interface IMemberService {
	public String idCheck(String id);
	public void insertMember(MemberDTO mDto);
	public MemberDTO selectMe(String userid);
	public int modifyMember(MemberDTO mDto);
}
