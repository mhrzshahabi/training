package com.nicico.training.repository;

import com.nicico.training.model.PostGradeGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PostGradeGroupDAO extends JpaRepository<PostGradeGroup, Long>, JpaSpecificationExecutor<PostGradeGroup> {
}
