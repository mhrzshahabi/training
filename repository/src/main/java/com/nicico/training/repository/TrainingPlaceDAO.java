package com.nicico.training.repository;

import com.nicico.training.model.TrainingPlace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingPlaceDAO extends JpaRepository<TrainingPlace, Long>, JpaSpecificationExecutor<TrainingPlace> {
}
