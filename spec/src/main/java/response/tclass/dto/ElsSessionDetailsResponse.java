package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;
@Getter
@Setter
public class ElsSessionDetailsResponse extends BaseResponse implements Serializable {
    private List<String> studentsNationalCodes;
    private String instructorNationalCode;
}
