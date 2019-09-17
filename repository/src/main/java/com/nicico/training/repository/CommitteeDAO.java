package com.nicico.training.repository;
import com.nicico.training.model.Committee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommitteeDAO extends JpaRepository<Committee, Long>, JpaSpecificationExecutor<Committee> {

  @Query(value = "SELECT  c_title_fa FROM tbl_committee where  (subcategory_id = :subcategory ) and (f_category_id = :category)", nativeQuery = true)
  List<String> findConflictCommittee(@Param("category") Long category, @Param("subcategory") Long subcategory);

  @Query(value = "SELECT  c_title_fa FROM tbl_committee where  (subcategory_id = :subcategory  and f_category_id = :category)  and id=:id", nativeQuery = true)
  List<String> findConflictWhenEdit (@Param("category") Long category, @Param("subcategory") Long subcategory,@Param( "id") Long id);
}
