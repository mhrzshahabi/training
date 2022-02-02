package com.nicico.training.repository;

import com.nicico.training.model.ViewClassConflict;
import com.nicico.training.model.compositeKey.ClassConflictKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface ViewClassConflictDAO extends JpaRepository<ViewClassConflict, ClassConflictKey>, JpaSpecificationExecutor<ViewClassConflict> {

    List<ViewClassConflict> findAllByTermId(Long termId);

    List<ViewClassConflict> findAllByClass1Id(Long classId);
}
