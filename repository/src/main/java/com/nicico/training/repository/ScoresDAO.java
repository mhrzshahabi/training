package com.nicico.training.repository;


import com.nicico.training.model.Scores;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ScoresDAO  extends JpaRepository<Scores,Long>, JpaSpecificationExecutor<Scores> {

//@Query(value = "SELECT tbl_student.id,tbl_student.first_name,tbl_student.last_name,tbl_class_student.f_class,tbl_scores.score,tbl_scores.scores_state FROM tbl_class_student right  JOIN tbl_student ON tbl_student.id = tbl_class_student.f_student LEFT JOIN tbl_scores ON tbl_student.id = tbl_scores.f_student_id WHERE tbl_class_student.f_class =:classid")

@Query(value = "SELECT tbl_student.id,tbl_student.first_name,tbl_student.last_name,tbl_class_student.f_class,tbl_scores.score,tbl_scores.scores_state FROM tbl_class_student right  JOIN tbl_student ON tbl_student.id = tbl_class_student.f_student LEFT JOIN tbl_scores ON tbl_student.id = tbl_scores.f_student_id WHERE tbl_class_student.f_class =:classid",nativeQuery = true)
List<Object> getCheckListId(@Param("classid") Long classid);

}
