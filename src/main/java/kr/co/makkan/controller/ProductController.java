package kr.co.makkan.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.service.IMemberService;
import kr.co.makkan.product.domain.CartDTO;
import kr.co.makkan.product.domain.ProductDTO;
import kr.co.makkan.product.service.IProductService;
import lombok.extern.log4j.Log4j;
import oracle.jdbc.proxy.annotation.Post;

@Controller
@RequestMapping("/product")
@Log4j
public class ProductController {
	@Autowired
	private IProductService proServ;
	@Autowired
	private IMemberService memServ;
	
	//상품 상세페이지 보기
	@GetMapping("/productView")
	public String proDetails(int proCode , Model model) {
		log.info("product details----------");
		ProductDTO pDto = proServ.selOneProduct(proCode);
		model.addAttribute("productDTO", pDto);
		return "/product/productview";
	}
	
	//쇼핑카트에 담기
	@PostMapping("/addCart")
	public String addCartAction(int proCode, String userId, RedirectAttributes rttr) {
		log.info("Add product shopping cart------");
		CartDTO cDto = new CartDTO();
		cDto.setProdNo(proCode);
		cDto.setUserId(userId);
		proServ.addCart(cDto);
		rttr.addFlashAttribute("message", "장바구니에 상품이 담겼습니다.");
		return "redirect:/product";
	}
	
	//쇼핑카트 페이지로 이동
	@GetMapping("/goCart")
	public String goCartPage() {
		return"/product/cart";
	}
	
	//장바구니 목록 Ajax 비동기 메소드
	@PostMapping("/cartList")
	public ResponseEntity<List<CartDTO>> cartList(String userId) {
		log.info("Shopping cart list---------");
		List<CartDTO> cartList = proServ.cartList(userId);
		if (cartList.isEmpty()) {
			return null;
		}
		return new ResponseEntity<List<CartDTO>>(cartList,HttpStatus.OK);
	}
	
	//장바구니 상품 수량 감소 Ajax
	@PostMapping("/decrease")
	public ResponseEntity<String> decrease(String userId, int prodNo){
		log.info("Cart amount decrease event-");
		CartDTO cDto = new CartDTO();
		cDto.setProdNo(prodNo);
		cDto.setUserId(userId);
		String result = null;
		int code = proServ.decrease(cDto);
		if (code > 0) {
			result = "success";
		} else result = "error";
		return new ResponseEntity<String>(result,HttpStatus.OK);
	}
	
	//장바구니 상품 수량 증가 Ajax
	@PostMapping("/increase")
	public ResponseEntity<String> increase(String userId, int prodNo){
		log.info("Cart amount increase event-");
		CartDTO cDto = new CartDTO();
		cDto.setProdNo(prodNo);
		cDto.setUserId(userId);
		String result = null;
		int code = proServ.increase(cDto);
		if (code > 0) {
			result = "success";
		} else result = "error";
		return new ResponseEntity<String>(result,HttpStatus.OK);
	}
	
	//모든 상품 삭제..
	@PostMapping("removeThis")
	public ResponseEntity<String> removeThis(String userId, int prodNo){
		log.info("remove this pro-------");
		String result= "";
		CartDTO cDto = new CartDTO();
		cDto.setProdNo(prodNo);
		cDto.setUserId(userId);
		int code = proServ.removeAll(cDto);
		if (code > 0) {
			result = "success";
		} else result = "error";
		return new ResponseEntity<String>(result,HttpStatus.OK);
	}
	
	//주문하기 요청시 회원정보 확인
	@PostMapping("/goOrder")
	public ResponseEntity<MemberDTO> goOrder(String userId){
		log.info("Order request------");
		MemberDTO result = memServ.selectMe(userId);
		return new ResponseEntity<MemberDTO>(result, HttpStatus.OK);
	}
}
