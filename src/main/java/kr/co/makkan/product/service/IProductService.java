package kr.co.makkan.product.service;

import java.util.List;

import kr.co.makkan.product.domain.CartDTO;
import kr.co.makkan.product.domain.ProductDTO;

public interface IProductService {
	public List<ProductDTO> selAllProduct();
	
	public ProductDTO selOneProduct(int proCode);
	
	public void addCart(CartDTO cDto);
	
	public List<CartDTO> cartList(String userId);
	
	public int decrease(CartDTO cDto);
	
	public int increase(CartDTO cDto);
	
	public int removeAll(CartDTO cDto);
}
