package com.nicico.training.repository;

import com.nicico.training.model.Term;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TermDAO extends JpaRepository<Term, Long>, JpaSpecificationExecutor<Term> {
    @Query(value = "select  C_TITLE_FA from training.TBL_TERM   where  (:eData >= c_startdate) and (:sData <= c_enddate)", nativeQuery = true)
    List<String> findConflict(@Param("sData") String sData, @Param("eData") String eData);

    @Query(value = "select  C_TITLE_FA from training.TBL_TERM   where  (:eData >= c_startdate) and (:sData <= c_enddate) and id<>:id", nativeQuery = true)
    List<String> findConflictWithoutThisTerm(@Param("sData") String sData, @Param("eData") String eData, @Param("id") Long id);

       List<Term> findByCodeStartingWith(String code);

}
