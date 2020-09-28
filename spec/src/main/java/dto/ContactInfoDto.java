package dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ContactInfoDto {
    private Long id;
    private String email;
    private String mobile;
    private String personalWebSite;
    private Long homeAddressId;
    private Long workAddressId;
}
