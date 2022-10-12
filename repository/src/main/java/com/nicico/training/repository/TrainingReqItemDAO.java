package com.nicico.training.repository;

import com.nicico.training.model.TrainingRequestItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingReqItemDAO extends JpaRepository<TrainingRequestItem, Long>, JpaSpecificationExecutor<TrainingRequestItem> {

 List<TrainingRequestItem> findAllByRefAndTrainingRequestManagementId(String ref,Long id);

}
