package response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SmsTracker extends BaseResponse{
private String number;
private String trackingNumber;
}
