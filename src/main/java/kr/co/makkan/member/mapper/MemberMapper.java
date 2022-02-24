package kr.co.makkan.member.mapper;


import kr.co.makkan.member.domain.MemberDTO;

public interface MemberMapper {
	public String idCheck(String id);
	public void insertMember(MemberDTO mDto);
	public void insertAuth(String id);
	public MemberDTO selectUser(String userid);
	public MemberDTO selectMe(String userid);
	public int modifyMember(MemberDTO mDto);
}
