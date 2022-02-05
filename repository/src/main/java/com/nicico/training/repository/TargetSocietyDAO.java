package com.nicico.training.repository;

import com.nicico.training.model.TargetSociety;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface TargetSocietyDAO extends BaseDAO<TargetSociety, Long> {

    List<TargetSociety> findAllByTclassId(Long id);

    @Modifying
    @Query(value = "delete from TBL_CLASS_TRAINING_PLACE where f_class_id = :id", nativeQuery = true)
    void deleteClassTrainingPlace(Long id);
}
