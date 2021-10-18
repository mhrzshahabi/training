package com.nicico.training.iservice;

import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.model.enums.RequestStatus;

import java.util.List;

public interface IRequestService {

    List<RequestResVM> findAll();

    List<RequestResVM> findAllByStatus(RequestStatus status);

    List<RequestResVM> findAllByNationalCode(String nationalCode);

    RequestResVM createRequest(RequestReqVM requestReqVM);

    RequestResVM changeStatus(String reference, RequestStatus status);

    RequestResVM findByReference(String reference);

    boolean remove(String reference);

    RequestResVM answerRequest(String reference, String response,RequestStatus status);

}
