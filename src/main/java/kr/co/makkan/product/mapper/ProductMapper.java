package kr.co.makkan.product.mapper;

import java.util.List;

import kr.co.makkan.product.domain.CartDTO;
import kr.co.makkan.product.domain.ProductDTO;

public interface ProductMapper {
	public List<ProductDTO> selAllProduct();
	
	public ProductDTO selOneProduct(int proCode);
	
	public void cartAdd(CartDTO cDto);
	
	public void cartRemove(CartDTO cDto);
	
	public CartDTO cartDuplicateChk(CartDTO cDto);
	
	public int increaseAmount(CartDTO cDto);
	
	public int decreaseAmount(CartDTO cDto);
	
	public List<CartDTO> cartList(String userId);
	
	public void removeEmptyCart(String userId);
	
	public int removeThis(CartDTO cDto);
}
