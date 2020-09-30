package dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PersonalInfoDto {
    private Long id;
    private String firstNameFa;
    private String lastNameFa;
    private String nationalCode;
    private ContactInfoDto contactInfo;
}
