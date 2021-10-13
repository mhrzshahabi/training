package response.requestItem;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RequestItemWithDiff {

    private Long id;
    private int wrongCount;

    private String personnelNumber;
    private String nationalCode;
    private String correctPersonnelNumber;
    private boolean isPersonnelNumberCorrect;

    private String name;
    private String correctName;
    private boolean isNameCorrect;

    private String lastName;
    private String correctLastName;
    private boolean isLastNameCorrect;

    private String affairs;
    private String correctAffairs;
    private boolean isAffairsCorrect;

    private String post;
    private String workGroupCode;
    private String state;


}
