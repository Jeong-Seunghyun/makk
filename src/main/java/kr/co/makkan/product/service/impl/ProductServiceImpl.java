package kr.co.makkan.product.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.makkan.product.domain.CartDTO;
import kr.co.makkan.product.domain.ProductDTO;
import kr.co.makkan.product.mapper.ProductMapper;
import kr.co.makkan.product.service.IProductService;
import lombok.extern.log4j.Log4j;

@Service
public class ProductServiceImpl implements IProductService{
	
	@Autowired
	private ProductMapper mapper;

	@Override
	public List<ProductDTO> selAllProduct() {
		return mapper.selAllProduct();
	}

	@Override
	public ProductDTO selOneProduct(int proCode) {
		return mapper.selOneProduct(proCode);
	}

	@Override
	public void addCart(CartDTO cDto) {
		//중복 상품이 있는지 먼저 확인..
		CartDTO chkCart = mapper.cartDuplicateChk(cDto);
		if (chkCart == null) {
			mapper.cartAdd(cDto);
		} else { //중복 상품이 있을때는 수량만 증가시킴
			mapper.increaseAmount(cDto);
		}
	}
	@Transactional
	@Override
	public int decrease(CartDTO cDto) {
		int result = mapper.decreaseAmount(cDto);
		//상품 수량이 0이 되면 카트 테이블에서 삭제
		mapper.removeEmptyCart(cDto.getUserId());
		return result;
	} 
	
	@Override
	public List<CartDTO> cartList(String userId) {
		return mapper.cartList(userId);
	}

	@Override
	public int increase(CartDTO cDto) {
		return mapper.increaseAmount(cDto);
	}

	@Override
	public int removeAll(CartDTO cDto) {
		
		return mapper.removeThis(cDto);
	}
	
}
