package response.requestItem;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RequestItemWithDiff {

    private Long id;
    private int wrongCount;
    private Long competenceReqId;

    private String nationalCode;
    private String correctNationalCode;
    private boolean isNationalCodeCorrect;

    private String personnelNumber;
    private String correctPersonnelNumber;
    private boolean isPersonnelNumberCorrect;

    private String personnelNo2;
    private String correctPersonnelNo2;
    private boolean isPersonnelNo2Correct;

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
    private String currentPostTitle;
    private String currentPostCode;
    private String workGroupCode;
    private String state;
}
