package request.student;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class StudentNationalCodeListDto implements Serializable {
    private List<StudentNationalCode> nationalCodeList;
}
