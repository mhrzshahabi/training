package response.student;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class UpdatePreTestScoreRequest implements Serializable {
    private static final long serialVersionUID = 4429383021997652624L;

    private float preTestScore;
}
