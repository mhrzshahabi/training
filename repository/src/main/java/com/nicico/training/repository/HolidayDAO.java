package com.nicico.training.repository;

import com.nicico.training.model.ClassSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface HolidayDAO extends JpaRepository<ClassSession, Long>, JpaSpecificationExecutor<ClassSession> {

    @Modifying
    @Query(value = "SELECT C_HOLIDAY FROM TBL_HOLIDAY WHERE C_HOLIDAY >= :startDate AND C_HOLIDAY <= :endDate", nativeQuery = true)
    @Transactional
    List<String> Holidays(@Param("startDate") String startDate, @Param("endDate") String endDate);
}
