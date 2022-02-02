package com.nicico.training.repository;

import com.nicico.training.model.compositeKey.PersonnelClassKey;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewPersonnelTrainingStatusReportDAO extends BaseDAO<com.nicico.training.model.ViewPersonnelTrainingStatusReport, PersonnelClassKey> {
}
