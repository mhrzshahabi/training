package com.nicico.training.repository;

/*
AUTHOR: ghazanfari_f
DATE: 6/12/2019
TIME: 7:49 AM
*/

import com.nicico.training.model.JobCompetence;
import com.nicico.training.model.JobCompetenceKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface JobCompetenceDAO extends JpaRepository<JobCompetence, Long>, JpaSpecificationExecutor<JobCompetence> {

    void deleteById(JobCompetenceKey key);

    Optional<JobCompetence> findById(JobCompetenceKey key);
}
