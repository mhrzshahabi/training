package com.nicico.training.repository;

import com.nicico.training.model.PresenceReportView;
import com.nicico.training.model.compositeKey.PresenceReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PresenceReportViewDAO extends JpaRepository<PresenceReportView, PresenceReportKey>, JpaSpecificationExecutor<PresenceReportView> {
}
