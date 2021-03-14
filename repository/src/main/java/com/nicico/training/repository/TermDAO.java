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
    @Query(value = "select  C_TITLE_FA from TBL_TERM   where  (:eData >= c_startdate) and (:sData <= c_enddate)", nativeQuery = true)
    List<String> findConflict(@Param("sData") String sData, @Param("eData") String eData);

    @Query(value = "select  C_TITLE_FA from TBL_TERM   where  (:eData >= c_startdate) and (:sData <= c_enddate) and id<>:id", nativeQuery = true)
    List<String> findConflictWithoutThisTerm(@Param("sData") String sData, @Param("eData") String eData, @Param("id") Long id);

    List<Term> findByCodeStartingWith(String code);

    @Query(value = "select distinct SUBSTR(c_code, 1, 4) from tbl_term", nativeQuery = true)
    List<String> getYearsList();

    @Query(value = "select distinct substr(tbl_term.c_startdate, 0, 4) year from tbl_term order by year desc", nativeQuery = true)
    List<String> getYearsFromStartDate();

    @Query(value = "select * from tbl_term where C_CODE like concat(:year,'%')", nativeQuery = true)
    List<Term> getTermByYear(String year);

    @Query(value = "select * from tbl_term where c_code=:code", nativeQuery = true)
    Term getTermByCode(String code);
}
