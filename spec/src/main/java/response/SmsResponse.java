package response;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SmsResponse extends BaseResponse{
    List<SmsTracker> receivers;
}
