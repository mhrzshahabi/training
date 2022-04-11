/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */


package com.nicico.training.iservice;


public interface IMessageParameterService {
    void delete(Long id);

    void deleteParamValueMessage(Long id);
}
