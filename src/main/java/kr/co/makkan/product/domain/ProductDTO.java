package kr.co.makkan.product.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Data
@ToString
public class ProductDTO {
	private int proCode;
	private String proName;
	private String proKind;
	private String proPrice;
	private String bestPro;
	private String dropPro;
	private String proExplane;
	private String proImage;
}
