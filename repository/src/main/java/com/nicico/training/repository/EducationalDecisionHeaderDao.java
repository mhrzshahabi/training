package com.nicico.training.repository;

import com.nicico.training.model.EducationalDecisionHeader;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EducationalDecisionHeaderDao extends JpaRepository<EducationalDecisionHeader, Long>, JpaSpecificationExecutor<EducationalDecisionHeader> {

    @Query(value = """
            SELECT
                            *
                        FROM
                            tbl_educational_decision_header edh
                        WHERE
                         (   ( ( edh.item_from_date <= :fromdate
                                AND edh.item_to_date >= :fromdate ) )
                            OR ( ( edh.item_to_date IS NULL )
                                 AND edh.item_from_date <= :fromdate ))
                            AND ( edh.complex = :complex )
                                                """, nativeQuery = true)
    List<EducationalDecisionHeader> findAllByFromDate(@Param("fromdate") String fromDate, @Param("complex") String complex);

}