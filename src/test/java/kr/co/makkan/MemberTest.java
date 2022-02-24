package kr.co.makkan;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.mapper.MemberMapper;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
@Log4j
public class MemberTest {
	
	@Autowired
	private MemberMapper mapper;
	
	/*
	 * @Test public void test() throws Exception{ String check =
	 * mapper.idCheck("suaca123"); log.info(check); }
	 */

}
