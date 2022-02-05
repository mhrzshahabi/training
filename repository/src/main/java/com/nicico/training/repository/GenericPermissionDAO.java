package com.nicico.training.repository;

import com.nicico.training.model.GenericPermission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface GenericPermissionDAO extends JpaRepository<GenericPermission, Long>, JpaSpecificationExecutor<GenericPermission> {

    @Transactional
    List<GenericPermission> findByObjectIdNotInAndAndWorkGroupIdAndObjectType(@Param("ids") List<Long> ids,
                                                                @Param("workGroupId") Long workGroupId,@Param("objectType") String ObjectType);

    @Transactional
    List<GenericPermission> findByObjectIdInAndAndWorkGroupIdAndObjectType(@Param("ids") List<Long> ids,
                                                                 @Param("workGroupId") Long workGroupId,@Param("objectType") String ObjectType);

    @Transactional
    List<GenericPermission> findAllByWorkGroupId(@Param("workGroupId") Long workGroupId);

    @Transactional
    List<GenericPermission> findByObjectTypeAndAndWorkGroupUserIds(@Param("objectType") String ObjectType,@Param("userId") Long UserId);
}
