package kr.co.makkan.member.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.mapper.MemberMapper;
import kr.co.makkan.member.service.IMemberService;
import lombok.extern.log4j.Log4j;

@Service
public class MemberServiceImpl implements IMemberService{
	
	@Autowired
	private MemberMapper mapper;
	
	@Override
	public String idCheck(String id) {
		String user = mapper.idCheck(id);
		return user;
	}
	
	@Transactional
	@Override
	public void insertMember(MemberDTO mDto) {
		mapper.insertMember(mDto);
		mapper.insertAuth(mDto.getUserid());
	}

	@Override
	public MemberDTO selectMe(String userid) {
		return mapper.selectMe(userid);
	}

	@Override
	public int modifyMember(MemberDTO mDto) {
		return mapper.modifyMember(mDto);
	}

}
