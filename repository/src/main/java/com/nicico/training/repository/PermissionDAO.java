package com.nicico.training.repository;

import com.nicico.training.model.Permission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public interface PermissionDAO extends JpaRepository<Permission, Long>, JpaSpecificationExecutor<Permission> {

    @Transactional
    Optional<Permission> findByEntityNameAndAndAttributeNameAndWorkGroupId(@Param("entityName") String entityName,
                                                                           @Param("attributeName") String attributeName,
                                                                           @Param("workGroupId") Long workGroupId);

    @Transactional
    List<Permission> findByEntityNameAndWorkGroupId(@Param("entityName") String entityName, @Param("workGroupId") Long workGroupId);

    @Transactional
    List<Permission> findByEntityName(@Param("entityName") String entityName);
}
