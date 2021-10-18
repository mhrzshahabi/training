package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.iservice.IRequestService;
import com.nicico.training.mapper.request.RequestMapper;
import com.nicico.training.model.Request;
import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.repository.RequestDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RequestService implements IRequestService {

    private final RequestDAO requestDAO;
    private final RequestMapper requestMapper;

    @Override
    public List<RequestResVM> findAll() {
        List<Request> all = requestDAO.findAll();
        return requestMapper.mapListEntityToRes(all);
    }

    @Override
    public List<RequestResVM> findAllByStatus(RequestStatus status) {
        List<Request> allByStatus = requestDAO.findAllByStatus(status);
        return requestMapper.mapListEntityToRes(allByStatus);
    }

    @Override
    @Transactional
    public RequestResVM createRequest(RequestReqVM requestReqVM) {
        Request request = requestMapper.mapReqToEntity(requestReqVM);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public RequestResVM changeStatus(String reference, RequestStatus status) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        request.setStatus(status);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public boolean remove(String reference) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        requestDAO.delete(request);
        return true;
    }

    @Override
    public RequestResVM answerRequest(String reference, String response,RequestStatus status) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        request.setResponse(response);
        request.setStatus(status);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public List<RequestResVM> findAllByNationalCode(String nationalCode) {
        List<Request> allByNationalCode = requestDAO.findAllByNationalCode(nationalCode);
        return requestMapper.mapListEntityToRes(allByNationalCode);
    }

    @Override
    public RequestResVM findByReference(String reference) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        return requestMapper.mapEntityToRes(request);
    }
}
