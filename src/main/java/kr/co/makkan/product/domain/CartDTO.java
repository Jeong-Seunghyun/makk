package kr.co.makkan.product.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class CartDTO {
	private String userId;
	private int prodNo;
	private int amount;
	private String proName;
	private int proPrice;
}
