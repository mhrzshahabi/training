package com.nicico.training.repository;

import com.nicico.training.model.CommitteePersonnel;
import com.nicico.training.model.CommitteePost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommitteePostDAO extends JpaRepository<CommitteePost, Long>, JpaSpecificationExecutor<CommitteePost> {
 List<CommitteePost> getAllByCommitteeOfExperts_Id(Long id);

}
