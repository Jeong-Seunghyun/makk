package kr.co.makkan.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.makkan.board.domain.BoardDTO;
import kr.co.makkan.board.domain.PageDTO;
import kr.co.makkan.board.service.IBoardService;
import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.service.IMemberService;
import kr.co.makkan.product.domain.ProductDTO;
import kr.co.makkan.product.service.IProductService;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class IndexController {
	
	@Autowired
	IMemberService service;
	@Autowired
	IBoardService boardServ;
	@Autowired
	IProductService proserv;
	
	@GetMapping("/")
	public String index(Authentication authentication) {
		log.info("index----------");
		
		return "/index/index";
	}
	
	@RequestMapping("/loginForm")
	public String login() {
		log.info("login page-------");
		return "/member/login";
	}
	
	@GetMapping("/term")
	public String term() {
		log.info("term page-----------");
		return "/member/term";
	}
	
	@GetMapping("/modifyMember")
	public String modifyMember(Principal princiapl, Model model) {
		log.info("modify Member-------------");
		String id = princiapl.getName();
		MemberDTO mDto = service.selectMe(id);
		if (id.equals(mDto.getUserid())) {
			model.addAttribute("member", mDto);
		}
		
		return "/member/modifymember";
	}
	
	@GetMapping("/product")
	public String menuList(Model model) {
		log.info("product page--------");
		List<ProductDTO> proList =  proserv.selAllProduct();
		model.addAttribute("proList",proList);
		return "/product/productlist";
	}
	
	@GetMapping("/store")
	public String store() {
		return "/store/store";
	}
}
