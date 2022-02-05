package com.nicico.training.iservice;

import com.nicico.training.dto.ViewLmsTrainingFileDTO;
import com.nicico.training.dto.ViewTrainingFileDTO;

import java.util.List;

public interface IViewTrainingFileService {
    ViewTrainingFileDTO.SpecRs getByNationalCode(String nationalCode);

    List<ViewLmsTrainingFileDTO> getDtoListByNationalCode(String nationalCode);
}
