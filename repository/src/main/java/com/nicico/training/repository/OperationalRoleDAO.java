package com.nicico.training.repository;

import com.nicico.training.model.OperationalRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface OperationalRoleDAO extends JpaRepository<OperationalRole, Long>, JpaSpecificationExecutor<OperationalRole> {
    Boolean findByCode(@Param("code") String roleCode);

    boolean existsOperationalRoleByCode(String roleCode);

    @Query(value = "SELECT rp.POST_IDS FROM TBL_OPERATIONAL_ROLE_POST_IDS rp where rp.F_OPERATIONAL_ROLE <> :roleId ", nativeQuery = true)
    List<Long> getUsedPostIdsInRoles(@Param("roleId")Long roleId);

   Optional<OperationalRole> findByPostIdsIn(Long postId);
}