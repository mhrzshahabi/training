package com.nicico.training.iservice;

import com.nicico.training.model.RequestItemAudit;

import java.util.List;

public interface IRequestItemAuditService {

    List<RequestItemAudit> getChangeList(List<Long> ids);
}
