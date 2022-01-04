package com.nicico.training.mapper.helpFiles;

import com.nicico.training.dto.FileLabelDTO;
import com.nicico.training.dto.HelpFilesDTO;
import com.nicico.training.iservice.IFileLabelService;
import com.nicico.training.model.*;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class HelpFilesBeanMapper {

    @Autowired
    protected IFileLabelService iFileLabelService;

    @Mapping(source = "fileLabels", target = "fileLabels", qualifiedByName = "getFileLabelByIds")
    public abstract HelpFiles toHelpFiles(HelpFilesDTO.Create create);

    @Mapping(source = "fileLabels", target = "fileLabels", qualifiedByName = "getFileLabelsInfo")
    public abstract HelpFilesDTO.Info toHelpFilesInfo(HelpFiles helpFiles);

    public abstract List<HelpFilesDTO.Info> toHelpFilesInfoList(List<HelpFiles> HelpFileList);


    @Named("getFileLabelByIds")
    Set<FileLabel> getFileLabelByIds(Set<Long> fileLabelIds) {
        Set<FileLabel> fileLabels = new HashSet<>();
        if (fileLabelIds != null && fileLabelIds.size() > 0) {
            fileLabels = iFileLabelService.getFileLabelByIds(fileLabelIds);
        }
        return fileLabels;
    }

    @Named("getFileLabelsInfo")
    Set<FileLabelDTO.Info> getFileLabelsInfo(Set<FileLabel> fileLabels) {
        Set<FileLabelDTO.Info> fileLabelsInfo = new HashSet<>();
        if (!fileLabels.isEmpty()) {
            fileLabelsInfo = iFileLabelService.getFileLabelsInfo(fileLabels);
        }
        return fileLabelsInfo;
    }

}
