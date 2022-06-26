package com.nicico.training.repository;

import com.nicico.training.model.CommitteeOfExperts;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CommitteeOfExpertsDAO extends JpaRepository<CommitteeOfExperts, Long>, JpaSpecificationExecutor<CommitteeOfExperts> {

}
