package request.dataForNewSkill;

import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
public class DataForNewSkillDto {
    private List<Object> list;
    private Long skillId;
}
