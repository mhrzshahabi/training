package com.nicico.training.repository;

import com.nicico.training.model.CommitteeOfExperts;
import com.nicico.training.model.CommitteePersonnel;
 import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommitteePersonnelDAO extends JpaRepository<CommitteePersonnel, Long>, JpaSpecificationExecutor<CommitteePersonnel> {
 List<CommitteePersonnel> getAllByCommitteeOfExperts_Id(Long id);

}
