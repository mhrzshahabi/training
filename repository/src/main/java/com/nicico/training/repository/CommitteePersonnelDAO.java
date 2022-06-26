package com.nicico.training.repository;

import com.nicico.training.model.CommitteePersonnel;
 import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CommitteePersonnelDAO extends JpaRepository<CommitteePersonnel, Long>, JpaSpecificationExecutor<CommitteePersonnel> {

}
