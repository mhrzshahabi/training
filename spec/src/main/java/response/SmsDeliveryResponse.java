package response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SmsDeliveryResponse extends BaseResponse{
    String state;
}
