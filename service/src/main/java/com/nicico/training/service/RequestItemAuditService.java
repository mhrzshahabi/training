package com.nicico.training.service;

import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.RequestItemAuditDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RequestItemAuditService implements IRequestItemAuditService {

    private final RequestItemAuditDAO requestItemAuditDAO;

    @Override
    public List<RequestItemAudit> getChangeList(List<Long> ids) {
        return requestItemAuditDAO.findAllByIds(ids);
    }

}
