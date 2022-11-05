package com.nicico.training.repository;

import com.nicico.training.model.ScoresByCommittee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ScoresByCommitteeDAO extends JpaRepository<ScoresByCommittee, Long> {

 @Query(value = "SELECT\n" +
         "    *\n" +
         "FROM\n" +
         "    tbl_scores_by_committee\n" +
         "WHERE\n" +
         "        tbl_scores_by_committee.c_national_code = :nationalCode\n" +
         "    AND tbl_scores_by_committee.f_course_id = :course", nativeQuery = true)
 Optional<ScoresByCommittee> getLasEnteredData(String nationalCode, Long course);
}
